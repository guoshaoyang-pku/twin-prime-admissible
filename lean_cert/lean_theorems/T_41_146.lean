import Sound
import lean_certs.cert_41_146

open CertVerify

theorem H41_gt_146 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 146 := by
  exact certValidRoot_sound (k := 41) (d := 146) (c := cert_41_146) (by native_decide)
