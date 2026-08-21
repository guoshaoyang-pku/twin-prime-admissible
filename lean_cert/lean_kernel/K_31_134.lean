import Sound
import lean_certs.cert_31_134

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H31_gt_134_kernel : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 31) (d := 134) (c := cert_31_134) (by decide)
