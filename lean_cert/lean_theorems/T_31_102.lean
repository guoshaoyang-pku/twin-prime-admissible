import Sound
import lean_certs.cert_31_102

open CertVerify

theorem H31_gt_102 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 102 := by
  exact certValidRoot_sound (k := 31) (d := 102) (c := cert_31_102) (by native_decide)
