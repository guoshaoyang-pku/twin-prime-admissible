import Sound
import lean_certs.cert_32_134

open CertVerify

theorem H32_gt_134 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 32) (d := 134) (c := cert_32_134) (by native_decide)
