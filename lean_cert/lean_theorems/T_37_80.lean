import Sound
import lean_certs.cert_37_80

open CertVerify

theorem H37_gt_80 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 80 := by
  exact certValidRoot_sound (k := 37) (d := 80) (c := cert_37_80) (by native_decide)
