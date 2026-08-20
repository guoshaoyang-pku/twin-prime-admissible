import Sound
import lean_certs.cert_48_174

open CertVerify

theorem H48_gt_174 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 174 := by
  exact certValidRoot_sound (k := 48) (d := 174) (c := cert_48_174) (by native_decide)
