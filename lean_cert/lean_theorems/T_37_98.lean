import Sound
import lean_certs.cert_37_98

open CertVerify

theorem H37_gt_98 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 37) (d := 98) (c := cert_37_98) (by native_decide)
