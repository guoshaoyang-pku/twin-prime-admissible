import Sound
import lean_certs.cert_39_176

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H39_gt_176_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 176 := by
  exact certValidRoot_sound (k := 39) (d := 176) (c := cert_39_176) (by decide)
