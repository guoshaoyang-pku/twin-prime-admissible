import Sound
import lean_certs.cert_31_80

open CertVerify

theorem H31_gt_80 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 80 := by
  exact certValidRoot_sound (k := 31) (d := 80) (c := cert_31_80) (by native_decide)
