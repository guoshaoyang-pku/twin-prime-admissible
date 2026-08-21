import Sound
import lean_certs.cert_25_84

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H25_gt_84_kernel : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 84 := by
  exact certValidRoot_sound (k := 25) (d := 84) (c := cert_25_84) (by decide)
