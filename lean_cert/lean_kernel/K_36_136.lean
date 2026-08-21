import Sound
import lean_certs.cert_36_136

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H36_gt_136_kernel : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 136 := by
  exact certValidRoot_sound (k := 36) (d := 136) (c := cert_36_136) (by decide)
