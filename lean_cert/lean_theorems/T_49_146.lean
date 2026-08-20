import Sound
import lean_certs.cert_49_146

open CertVerify

theorem H49_gt_146 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 146 := by
  exact certValidRoot_sound (k := 49) (d := 146) (c := cert_49_146) (by native_decide)
