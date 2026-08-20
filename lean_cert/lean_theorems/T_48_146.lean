import Sound
import lean_certs.cert_48_146

open CertVerify

theorem H48_gt_146 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 146 := by
  exact certValidRoot_sound (k := 48) (d := 146) (c := cert_48_146) (by native_decide)
