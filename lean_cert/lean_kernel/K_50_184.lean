import Sound
import lean_certs.cert_50_184

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_184_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 184 := by
  exact certValidRoot_sound (k := 50) (d := 184) (c := cert_50_184) (by decide)
