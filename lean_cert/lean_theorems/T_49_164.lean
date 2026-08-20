import Sound
import lean_certs.cert_49_164

open CertVerify

theorem H49_gt_164 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 164 := by
  exact certValidRoot_sound (k := 49) (d := 164) (c := cert_49_164) (by native_decide)
