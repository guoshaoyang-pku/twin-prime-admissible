import Sound
import lean_certs.cert_31_108

open CertVerify

theorem H31_gt_108 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 31) (d := 108) (c := cert_31_108) (by native_decide)
