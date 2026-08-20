import Sound
import lean_certs.cert_37_136

open CertVerify

theorem H37_gt_136 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 136 := by
  exact certValidRoot_sound (k := 37) (d := 136) (c := cert_37_136) (by native_decide)
