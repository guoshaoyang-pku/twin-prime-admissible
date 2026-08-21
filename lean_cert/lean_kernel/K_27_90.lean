import Sound
import lean_certs.cert_27_90

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H27_gt_90_kernel : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 90 := by
  exact certValidRoot_sound (k := 27) (d := 90) (c := cert_27_90) (by decide)
