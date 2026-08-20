import Sound
import lean_certs.cert_49_174

open CertVerify

theorem H49_gt_174 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 174 := by
  exact certValidRoot_sound (k := 49) (d := 174) (c := cert_49_174) (by native_decide)
