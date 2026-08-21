import Sound
import lean_certs.cert_19_62

open CertVerify

theorem H19_gt_62 : ¬ ∃ t : List Nat, admissible 19 t = true ∧ diameter t ≤ 62 := by
  exact certValidRoot_sound (k := 19) (d := 62) (c := cert_19_62) (by native_decide)
