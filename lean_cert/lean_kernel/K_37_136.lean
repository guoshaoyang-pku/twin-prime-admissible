import Sound
import lean_certs.cert_37_136

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_136_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 136 := by
  exact certValidRoot_sound (k := 37) (d := 136) (c := cert_37_136) (by decide)
