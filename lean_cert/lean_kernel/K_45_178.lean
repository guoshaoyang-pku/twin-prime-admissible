import Sound
import lean_certs.cert_45_178

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_178_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 178 := by
  exact certValidRoot_sound (k := 45) (d := 178) (c := cert_45_178) (by decide)
