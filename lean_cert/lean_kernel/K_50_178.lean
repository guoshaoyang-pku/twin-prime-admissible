import Sound
import lean_certs.cert_50_178

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_178_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 178 := by
  exact certValidRoot_sound (k := 50) (d := 178) (c := cert_50_178) (by decide)
