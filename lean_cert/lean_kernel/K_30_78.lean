import Sound
import lean_certs.cert_30_78

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H30_gt_78_kernel : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 30) (d := 78) (c := cert_30_78) (by decide)
