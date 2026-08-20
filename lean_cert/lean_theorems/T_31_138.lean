import Sound
import lean_certs.cert_31_138

open CertVerify

theorem H31_gt_138 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 138 := by
  exact certValidRoot_sound (k := 31) (d := 138) (c := cert_31_138) (by native_decide)
