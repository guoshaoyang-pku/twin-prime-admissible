import Sound
import lean_certs.cert_27_72

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H27_gt_72_kernel : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 72 := by
  exact certValidRoot_sound (k := 27) (d := 72) (c := cert_27_72) (by decide)
