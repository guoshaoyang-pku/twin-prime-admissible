import Sound
import lean_certs.cert_45_136

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_136_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 136 := by
  exact certValidRoot_sound (k := 45) (d := 136) (c := cert_45_136) (by decide)
