import Sound
import lean_certs.cert_44_178

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_178_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 178 := by
  exact certValidRoot_sound (k := 44) (d := 178) (c := cert_44_178) (by decide)
