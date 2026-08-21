import Sound
import lean_certs.cert_26_78

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H26_gt_78_kernel : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 26) (d := 78) (c := cert_26_78) (by decide)
