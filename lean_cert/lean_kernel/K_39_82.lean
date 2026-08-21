import Sound
import lean_certs.cert_39_82

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_82_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 39) (d := 82) (c := cert_39_82) (by decide)
