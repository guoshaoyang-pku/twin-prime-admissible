import Sound
import lean_certs.cert_32_134

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H32_gt_134_kernel : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 32) (d := 134) (c := cert_32_134) (by decide)
