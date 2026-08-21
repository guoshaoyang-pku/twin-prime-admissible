import Sound
import lean_certs.cert_39_136

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_136_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 136 := by
  exact certValidRoot_sound (k := 39) (d := 136) (c := cert_39_136) (by decide)
