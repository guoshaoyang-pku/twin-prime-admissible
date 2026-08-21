import Sound
import lean_certs.cert_44_136

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_136_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 136 := by
  exact certValidRoot_sound (k := 44) (d := 136) (c := cert_44_136) (by decide)
