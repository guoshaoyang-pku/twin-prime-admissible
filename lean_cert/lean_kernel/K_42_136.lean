import Sound
import lean_certs.cert_42_136

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_136_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 136 := by
  exact certValidRoot_sound (k := 42) (d := 136) (c := cert_42_136) (by decide)
