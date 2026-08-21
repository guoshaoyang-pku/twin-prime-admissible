import Sound
import lean_certs.cert_39_108

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_108_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 39) (d := 108) (c := cert_39_108) (by decide)
