import Sound
import lean_certs.cert_41_136

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H41_gt_136_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 136 := by
  exact certValidRoot_sound (k := 41) (d := 136) (c := cert_41_136) (by decide)
