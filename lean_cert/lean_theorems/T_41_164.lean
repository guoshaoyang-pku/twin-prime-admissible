import Sound
import lean_certs.cert_41_164

open CertVerify

theorem H41_gt_164 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 164 := by
  exact certValidRoot_sound (k := 41) (d := 164) (c := cert_41_164) (by native_decide)
