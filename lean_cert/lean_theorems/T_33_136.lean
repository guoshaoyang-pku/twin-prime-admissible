import Sound
import lean_certs.cert_33_136

open CertVerify

theorem H33_gt_136 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 136 := by
  exact certValidRoot_sound (k := 33) (d := 136) (c := cert_33_136) (by native_decide)
