import Sound
import lean_certs.cert_27_78

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H27_gt_78_kernel : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 27) (d := 78) (c := cert_27_78) (by decide)
