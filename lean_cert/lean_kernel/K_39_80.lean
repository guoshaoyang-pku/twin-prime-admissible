import Sound
import lean_certs.cert_39_80

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_80_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 80 := by
  exact certValidRoot_sound (k := 39) (d := 80) (c := cert_39_80) (by decide)
