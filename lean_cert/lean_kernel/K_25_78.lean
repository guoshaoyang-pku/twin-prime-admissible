import Sound
import lean_certs.cert_25_78

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H25_gt_78_kernel : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 25) (d := 78) (c := cert_25_78) (by decide)
