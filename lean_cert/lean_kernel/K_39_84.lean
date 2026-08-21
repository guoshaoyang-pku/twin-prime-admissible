import Sound
import lean_certs.cert_39_84

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_84_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 84 := by
  exact certValidRoot_sound (k := 39) (d := 84) (c := cert_39_84) (by decide)
