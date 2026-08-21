import Sound
import lean_certs.cert_27_84

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H27_gt_84_kernel : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 84 := by
  exact certValidRoot_sound (k := 27) (d := 84) (c := cert_27_84) (by decide)
