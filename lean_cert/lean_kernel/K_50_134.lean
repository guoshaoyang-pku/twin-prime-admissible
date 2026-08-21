import Sound
import lean_certs.cert_50_134

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_134_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 50) (d := 134) (c := cert_50_134) (by decide)
