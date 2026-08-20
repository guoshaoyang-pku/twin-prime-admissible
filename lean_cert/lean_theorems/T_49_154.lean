import Sound
import lean_certs.cert_49_154

open CertVerify

theorem H49_gt_154 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 154 := by
  exact certValidRoot_sound (k := 49) (d := 154) (c := cert_49_154) (by native_decide)
