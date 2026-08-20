import Sound
import lean_certs.cert_31_122

open CertVerify

theorem H31_gt_122 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 31) (d := 122) (c := cert_31_122) (by native_decide)
