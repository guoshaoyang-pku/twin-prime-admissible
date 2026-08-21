import Sound
import lean_certs.cert_24_82

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H24_gt_82_kernel : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 24) (d := 82) (c := cert_24_82) (by decide)
