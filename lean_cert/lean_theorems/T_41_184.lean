import Sound
import lean_certs.cert_41_184

open CertVerify

theorem H41_gt_184 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 184 := by
  exact certValidRoot_sound (k := 41) (d := 184) (c := cert_41_184) (by native_decide)
