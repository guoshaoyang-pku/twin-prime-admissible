import Sound
import lean_certs.cert_49_216

open CertVerify

theorem H49_gt_216 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 216 := by
  exact certValidRoot_sound (k := 49) (d := 216) (c := cert_49_216) (by native_decide)
