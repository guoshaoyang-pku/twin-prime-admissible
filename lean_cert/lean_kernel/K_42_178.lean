import Sound
import lean_certs.cert_42_178

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_178_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 178 := by
  exact certValidRoot_sound (k := 42) (d := 178) (c := cert_42_178) (by decide)
