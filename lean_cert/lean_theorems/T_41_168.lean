import Sound
import lean_certs.cert_41_168

open CertVerify

theorem H41_gt_168 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 168 := by
  exact certValidRoot_sound (k := 41) (d := 168) (c := cert_41_168) (by native_decide)
