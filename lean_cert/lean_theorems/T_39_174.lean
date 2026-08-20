import Sound
import lean_certs.cert_39_174

open CertVerify

theorem H39_gt_174 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 174 := by
  exact certValidRoot_sound (k := 39) (d := 174) (c := cert_39_174) (by native_decide)
