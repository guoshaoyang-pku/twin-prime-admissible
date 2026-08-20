import Sound
import lean_certs.cert_37_140

open CertVerify

theorem H37_gt_140 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 37) (d := 140) (c := cert_37_140) (by native_decide)
