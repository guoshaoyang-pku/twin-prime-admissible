import Sound
import lean_certs.cert_29_78

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H29_gt_78_kernel : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 29) (d := 78) (c := cert_29_78) (by decide)
