import Sound
import lean_certs.cert_25_82

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H25_gt_82_kernel : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 25) (d := 82) (c := cert_25_82) (by decide)
