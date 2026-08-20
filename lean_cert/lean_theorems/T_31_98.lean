import Sound
import lean_certs.cert_31_98

open CertVerify

theorem H31_gt_98 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 31) (d := 98) (c := cert_31_98) (by native_decide)
